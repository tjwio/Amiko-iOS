#!/bin/sh

if [[ $TRAVIS_COMMIT_MESSAGE == *"[fastlane deploy beta]"* ]]; then
  ./fastlane/setupGit.sh
  bundle exec fastlane travis_beta
  exit $?
fi

exit 0
