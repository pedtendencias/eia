module Eia
VERSION = "1.8.9"

#Standard for version: xx.yy.zz
# xx - release
# yy - feature
# zz - hotfix

# Version 0.1.1
# Fixes gemspec refference to net.
# Adds refference to ibge.rb in lib/eba.rb
# Fixes implementation of get in test_connection

# Version 0.2.1
# Adds rspec test for connection with the webservice

# Version 0.3.1
# Adds data standardization

# Version 1.0.0
# First release.
# Fully supports most data points from IBGE.
# Tests cover all features.
# Appropriate error treatment.

# Version 1.0.1
# Fixes periodicty, as to be able to relate possible periodicities from 0 to 5

# Version 1.1.1
# adds table_code to data type

# Version 1.1.2
# Was taking the wrong date from IBGE's output, not it gets the right one.

# Version 1.1.3
# Another fixup on data classification and parsing.

# Version 1.1.4
# Adds getter for periodicity in data type, which I had forgot.
# Also adds periodicity to integrity verification.

# Version 1.2.5
# Adds a new date classification for data.
# Renames procut as classification, as it's according what actual data in the source is like.
# Properly identifies classifications and stores then.

# Version 1.3.5
# Expanded spec tests.

# Version 1.3.6
# Handles correctly monthly series.

# Version 1.4.6
# Adds support for multiple classifications.

# Version 1.5.7
# Adds support for "Trimestre" periodicity.
# Updates spec tests, as the classification used for a test was no longer valid.

# Version 1.6.7
# Adds tests for "Trimestre" periodicity.

# Version 1.7.7
# Improves logging by adding backtrace.

# Version 1.8.7
# Indentifies 'Trimestre móvel' as code 6 for periodicity, differing it from 'Trimestre'.

# Version 1.8.8
# Fixes is_valid? to reconise the new periodicity as valid.

# Version 1.8.9
# Fixes gem push
end
