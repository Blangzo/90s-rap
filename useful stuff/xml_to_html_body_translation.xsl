<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    <!-- start -->
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <title><xsl:value-of select="//songTitle"/> by <xsl:value-of select="//artist"/></title>
                <link rel="stylesheet" type="text/css" href="lyrics.css"/>
                <script type="text/javascript" src="lyrics.js" xml:space="preserve"></script>
            </head>
            <body>
                <div id="sidebar">
                    <div id="legend">
                        <div id="fieldset">
                            <fieldset>
                                <legend>Click to Highlight:</legend>
                                <input type="checkbox" id="profanitytoggle" style="cursor:pointer" />
                                <span class="Testchars">Profanity</span>
                                <br />
                                <input type="checkbox" id="lifeEventtoggle" style="cursor:pointer" />
                                <span class="Testplaces">Life Events</span>
                                <br />
                                <input type="checkbox" id="dttoggle" style="cursor:pointer" />
                                <span class="Testobjects">Derogatory Terms</span>
                                <br />
                                <input type="checkbox" id="emotiontoggle" style="cursor:pointer" />
                                <span class="Testconcepts">Emotions</span>
                                <br />
                            </fieldset>
                        </div>
                    </div>
                </div>
                <!-- main body -->
                <div id="main">
                    <xsl:apply-templates select="//head"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="head">
        <h1><xsl:text>Song Title: </xsl:text><xsl:apply-templates select="//songTitle"/></h1>
        <h2><xsl:text>Artist: </xsl:text><xsl:apply-templates select="//artist"/></h2>
        <xsl:for-each select="//featuredArtist">
            <h3><xsl:text>Featured Artist: </xsl:text><xsl:apply-templates/></h3>
        </xsl:for-each>
        <xsl:for-each select="//producer">
            <h4><xsl:text>Producer: </xsl:text><xsl:apply-templates/></h4>
        </xsl:for-each>
        <h4><xsl:text>Album: </xsl:text><xsl:apply-templates select="//album"/></h4>
        <h4><xsl:text>Certification: </xsl:text><xsl:apply-templates select="//certification"/></h4>
        <xsl:apply-templates select="../lyrics"></xsl:apply-templates>
        <xsl:text> </xsl:text><br/><xsl:text> </xsl:text>
        <hr/>
    </xsl:template>
    
    <xsl:template match="//lyrics">
        <xsl:for-each select="node()">
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::singer">
                        <xsl:text>Singer: </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text> </xsl:text><br/><xsl:text> </xsl:text><xsl:text> </xsl:text><br/><xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:when test="self::featuredSinger">
                        <xsl:text>Featured Singer: </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text> </xsl:text><br/><xsl:text> </xsl:text><xsl:text> </xsl:text><br/><xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:when test="self::line">
                        <xsl:apply-templates/>
                        <xsl:text> </xsl:text><br/><xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text> </xsl:text><br/><xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="phrase">
        <span class="{@type}"><xsl:apply-templates/></span>
    </xsl:template>
</xsl:stylesheet>