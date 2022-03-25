pipeline {
    agent none
    stages {
        stage('Setup Parameters') {
            steps {
                script {
                    properties([
                            parameters([
                                    gitParameter(
                                            name: 'IOS_Branch',
                                            branchFilter: 'origin/hotfix/.*|origin/release/.*|origin/feature/.*|origin/bugfix/.*',
                                            defaultValue: 'develop',
                                            tagFilter: '*',
                                            sortMode: 'DESCENDING_SMART',
                                            selectedValue: 'NONE',
                                            quickFilterEnabled: true,
                                            listSize: '5',
                                            description: 'Please choose branch*',
                                            type: 'PT_BRANCH',
                                            useRepository: '.*ios.git'
                                    ),
                                    gitParameter(
                                            name: 'BMW_Branch',
                                            branchFilter: 'origin/hotfix/.*|origin/release/.*|origin/feature/.*|origin/bugfix/.*',
                                            defaultValue: 'develop',
                                            tagFilter: '*',
                                            sortMode: 'DESCENDING_SMART',
                                            selectedValue: 'NONE',
                                            quickFilterEnabled: true,
                                            listSize: '5',
                                            description: 'Please choose branch*',
                                            type: 'PT_BRANCH',
                                            useRepository: '.*bmw.git'
                                    ),
                                     choice(
                                        name:'IOS_ENV',
                                        choices:['CN-OCP-SIT1','CN-OCP-NFS','CN-SIT-BAU','CN-SIT-CHT','PRODUCTION','PILOT'],
                                        defaultValue: 'CN-OCP-SIT1',
                                        description:'iOS Build Environment'
                                    ),
                                      choice(
                                        name:'BMW_ENV',
                                        choices:['CN-OCP','PROD','NFS-APP-IBANK-CN-BSOI','BSOI-CN-NCH-DK'],
                                        defaultValue: 'CN-OCP',
                                        description:'Android Build Environment'
                                    ),
                                       choice(
                                        name:'Build_Target',
                                        choices:['BreezeCN-Testing','BreezeCN-Production'],
                                        defaultValue: 'BreezeCN-Testing',
                                        description:'iOS Build Target'
                                    ),
                                    string(
                                            defaultValue: '',
                                            name: 'App_Version',
                                            trim: true
                                    ),
                                    string(
                                            defaultValue: '',
                                            name: 'Build_Number',
                                            trim: true
                                    ),
                                    booleanParam(
                                        name: 'rasp',
                                        defaultValue: true,
                                        description: 'rasp package'
                                    )
                            ])
                    ])
                }
            }
        }
        stage('Checkout BMW Source Code') {
            agent {
                docker {
                    label 'Leia'
                    image 'cache.artifactory.global.standardchartered.com/node:10.15.3'
                    args '-u root:root --mount type=bind,source=$WORKSPACE,target=/src -w /src'
                }
            }
            steps {
                checkout([
                        $class                           : 'GitSCM',
                        branches                         : [[name: params.BMW_Branch]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions                       : [
                                [$class: 'PruneStaleBranch'],
                                [$class: 'RelativeTargetDirectory', relativeTargetDir: 'breeze-cn-bmw'],
                                [$class: 'CloneOption', depth: 0, timeout: 100]
                        ],
                        gitTool                          : '2220',
                        submoduleCfg                     : [],
                        userRemoteConfigs                : [[credentialsId: 'g.P50873.01', url: 'https://bitbucket.global.standardchartered.com/scm/rnp/breeze-cn-bmw.git']]
                ])
            }
        }
        stage('Checkout IOS Source Code') {
            agent {
                node {
                    label "Luke"
                }
            }
            steps {
                checkout([
                        $class                           : 'GitSCM',
                        branches                         : [[name: params.IOS_Branch]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions                       : [
                                [$class: 'PruneStaleBranch'],
                                [$class: 'RelativeTargetDirectory', relativeTargetDir: 'breeze-cn-ios'],
                                [$class: 'CloneOption', depth: 0, timeout: 30]
                        ],
                        gitTool                          : '2220',
                        submoduleCfg                     : [],
                        userRemoteConfigs                : [[credentialsId: 'g.P50873.01', url: 'https://bitbucket.global.standardchartered.com/scm/rnp/breeze-cn-ios.git']]
                ])
            }
        }
        stage('Build OMF Assets') {
            agent {
                docker {
                    label 'Leia'
                    image 'cache.artifactory.global.standardchartered.com/node:10.15.3'
                    args '-u root:root --mount type=bind,source=$WORKSPACE,target=/src -w /src'
                }
            }
            steps {
                dir('breeze-cn-bmw/') {
                    sh 'node -v'
                    echo 'Start to install dependencies'
                    sh '''
                        npm config set registry https://artifactory.global.standardchartered.com/artifactory/api/npm/npm-release
                        npm ci
                    '''
                    echo 'Start to build OMF'
                    sh 'npm run build -- --interface ' + params.BMW_ENV + ' --target mobile --platform ios --omf'
                    stash name: "my-stash", includes: "build/release/OMFApp/**/*"
                }
            }
        }
        stage('Build Package') {
            agent {
                node {
                    label "Luke"
                }
            }
            environment {
                DEVELOPER_DIR = "${HOME}/Applications/Xcode.app/Contents/Developer"
                LANGUAGE = "en_US.UTF-8"
                LC_ALL = "en_US.UTF-8"
                LANG = "en_US.UTF-8"
            }
            steps {
                dir("my-stash") {
                    echo "Get OMF package form docker"
                    unstash "my-stash"
                }
                dir("breeze-cn-ios") {
                    echo "Start to clean iOS workspace"
                    sh '''
                         git clean -dfx
                         git checkout -- .
                         rm -rf iphone/build/Release-iphoneos/BreezeCN.xcarchive
                         rm -rf iphone/build/Release-iphoneos/BreezeCN.ipa
                      '''
                    echo "Start to copy OMF assets"
                    sh '''
                        rm -rf iphone/Cordova/omf_www/*
                        cp -rf iphone/Cordova/platform_www/* iphone/Cordova/omf_www/
                        cp -rf ../my-stash/build/release/OMFApp/* iphone/Cordova/omf_www/
                      '''
                    echo "Start to build iOS package"
                    sh "./prebuild-script/BMW-iOS.sh " + params.IOS_ENV + " " + "No" + " " + "No" + " " + "yes"
                    dir("iphone") {
                        echo "Start to install pod dependencies"
                        sh "pod install"
                        echo "xcode version"
                        sh "xcodebuild -version"

                        echo "Archive iOS package"
                        sh "xcodebuild -workspace Breeze.xcworkspace -scheme \"" + params.Build_Target + "\" -configuration Release clean archive -archivePath build/Release-iphoneos/BreezeCN.xcarchive -allowProvisioningUpdates CLANG_ENABLE_MODULES=YES"

                        echo "Export iOS archive package"
                        sh "xcodebuild -exportArchive -archivePath build/Release-iphoneos/BreezeCN.xcarchive -exportPath build/Release-iphoneos -exportOptionsPlist ExportOptions.plist -allowProvisioningUpdates"
                    }
                }
            }
        }
        stage("Rasp package"){
            agent{
                node {
                    label "Luke"
                }
            }
            environment {
                DEVELOPER_DIR = "${HOME}/Applications/Xcode.app/Contents/Developer"
                LANGUAGE = "en_US.UTF-8"
                LC_ALL = "en_US.UTF-8"
                LANG = "en_US.UTF-8"
            }
            steps{
                script{
                def buildPackageName = params.Build_Target == 'BreezeCN-Production' ? 'BreezeCN.ipa' : 'BreezeCN-Testing.ipa'
                if(params.rasp){
                    dir("breeze-cn-ios/iphone"){
                        sh "pwd"
                        sh 'ls -ltrha'
                        sh "bundle exec fastlane rasp_package packageName:BreezeCN.ipa"
                        sh 'ls -ltrha'
                        dir("build/Release-iphoneos"){
                            sh 'ls -ltrha'
                        }
                    }
                }
                dir("breeze-cn-ios"){
                    if(params.rasp){
                        sh "pwd"
                        sh 'ls -ltrha'
                        sh "./postbuild-script/Resign-iOS.sh "+params.Build_Target+"-RASP " + params.App_Version + " " + params.Build_Number + " com.sc.breezecn.banking"
                        dir("iphone/build/Release-iphoneos"){
                            echo "Start archive rasp resigned ios package"
                            archiveArtifacts artifacts: params.Build_Target+"-RASP-Resigned.ipa", onlyIfSuccessful: true
                        }
                    }else{
                        sh "pwd"
                        sh "ls -ltrha"
                        sh "./postbuild-script/Resign-iOS.sh " + params.Build_Target + " " + params.App_Version + " " + params.Build_Number + " com.sc.breezecn.banking"
                        dir("iphone/build/Release-iphoneos"){
                            echo "Start archive rasp resigned ios package"
                            archiveArtifacts artifacts: params.Build_Target+".ipa", onlyIfSuccessful: true
                        }
                    }
                }
                }
            }
        }
        stage("Upload Package") {
            agent {
                node {
                    label "Luke"
                }
            }
            environment {
                LANGUAGE = "en_US.UTF-8"
                LC_ALL = "en_US.UTF-8"
                LANG = "en_US.UTF-8"
            }
            steps {
                script{
                    dir("breeze-cn-ios/iphone") {
                    echo "Use fastlane to upload package"
                    ansiColor("xterm") {
                        if(params.rasp){
                            sh "bundle exec fastlane ios upload_pacage packageName:"+params.Build_Target+"-RASP-Resigned.ipa --verbose"
                        }else{
                            sh "bundle exec fastlane ios upload_pacage packageName:"+params.Build_Target+".ipa --verbose"
                        }
                    }

                    echo "Upload package to local artifactory"
                }
                }
            }
        }
    }
}