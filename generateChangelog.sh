#!/usr/bin/env bash

github_changelog_generator --token $1 --issue-line-labels 'ALL' --unreleased
