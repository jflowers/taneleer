#!/usr/bin/env bash

export APPLICATION_SHORT_VERSION_PREFIX="1.0."
export APPLICATION_LONG_VERSION_PREFIX="${APPLICATION_SHORT_VERSION_PREFIX}0."

export GROUP_ID_BASE='com.jayflowers'
export ARTIFACT_ID_BASE='taneleer'

export RUBY_VERSION=2.2.4

export VAGRANT_BOXES_CENTOS_NAME='centos/6.7'
export VAGRANT_BOXES_CENTOS_VERSION='1.0.10.next'

export VAGRANT_BOXES_WINDOWS_NAME='windows/10'
export VAGRANT_BOXES_WINDOWS_VERSION='?'

export VAGRANT_BOXES_OSX_NAME='osx/10.11.3'
export VAGRANT_BOXES_OSX_VERSION='?'

export AWS_REGIONS=()
function choose_aws_region() {
  AWS_REGIONS=()

  AWS_REGIONS+=("ap-northeast-1")
  AWS_REGIONS+=("ap-northeast-2")
  AWS_REGIONS+=("ap-south-1")
  AWS_REGIONS+=("ap-southeast-1")
  AWS_REGIONS+=("ap-southeast-2")
  AWS_REGIONS+=("ca-central-1")
  AWS_REGIONS+=("eu-central-1")
  AWS_REGIONS+=("eu-west-1")
  AWS_REGIONS+=("eu-west-2")
  AWS_REGIONS+=("sa-east-1")
  AWS_REGIONS+=("us-east-1")
  AWS_REGIONS+=("us-east-2")
  AWS_REGIONS+=("us-west-1")
  AWS_REGIONS+=("us-west-2")

  while true; do
    printf "\n"
    printf "\n"
    echo "  Choose a vagrant provider:"

    local count=0
    local aws_region=''
    for aws_region in "${AWS_REGIONS[@]}"
    do
      aws_region_choice="${aws_region}"
      let "count++"
      echo "     $count. $aws_region_choice"
    done

    local answer=''
    read -p "    choose (1-$count): " answer

    local original_answer=$answer
    let "answer--"
    if [[ -n "${AWS_REGIONS[$answer]}" ]] ; then
      export AWS_REGION="${AWS_REGIONS[$answer]}"
      break
    else
      echo "Invalid option: $original_answer"
    fi

  done
}

function after_bootstrap(){
  arm_timebombs
}

function after_workspace_settings(){
  if [[ "$VAGRANT_DEFAULT_PROVIDER" == aws || $WORKSPACE_SETTING == packer ]]; then
    choose_aws_region
  fi

  _rake_complete
}

export PATH=/Applications/Deluge.app/Contents/MacOS:$PATH
