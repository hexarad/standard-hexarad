# Standard::Hexarad

At Hexarad we use the standard ruby code linter.

This repo contains the standard plugin we can use across the company ruby applications.

## Installation

Add to Gemfile

    gem "standard-hexarad", git: "git@github.com:hexarad/standard-hexarad.git"

Change `.standard.yml` to read

    plugins:
      - standard-rails
      - standard-hexarad
