# Docbook.profile
# Brooke Smith 2007 10 20

#############################################
# DOCBOOK
#############################################
DOCBOOK_XSL=/Users/bsmith/Sites/stylesheet/docbook-xsl

test -r $DOCBOOK_XSL/.profile.incl && source $DOCBOOK_XSL/.profile.incl

#############################################
# XSLTPROC
#############################################
export XML_CATALOG_FILES=/Users/bsmith/Sites/stylesheet/docbook-xsl/catalog.xml;
