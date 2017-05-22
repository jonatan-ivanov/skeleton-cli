#!/usr/bin/env groovy

"${System.getProperty('user.home')}/.sk/tools/check-for-update.sh".execute().waitForProcessOutput(System.out, System.err)

println 'skeleton-cli'
args.each { println it }
