<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">

    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>

    <xsl:variable name="scoll" select="collection('markedup_songs')"/>

    <xsl:template match="/">
        <html>
           
            <head>
                <title>90s-Rap Project Song Lyrics</title>
                <!-- only a few songs have perfect markup so I used those -->
                <!-- this is just the song display. It can be linked to a toc, but Monica and I agreed she would do the toc for xslt7 and I would do the songs-->
                <link rel="stylesheet" type="text/css" href="Ho_11-3_XSLT7.css"/>
            </head>
            <body>
                <h1>90s-Rap Project Song Lyrics</h1>
                <h2>Lyrics</h2>
                <hr/>
                <!-- body -->
                <div id="main">
                    <xsl:apply-templates select="$scoll/song[descendant::line]//head"/>                   
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- here, I chose to break things up just to simplify things -->
    <!--<xsl:template match="song">
        <xsl:apply-templates/>
        <xsl:apply-templates select="head"/>
        <xsl:apply-templates select="lyrics"/>
    </xsl:template>-->
    
    
    <xsl:template match="head">
        <h3><xsl:text>Song Title: </xsl:text><xsl:apply-templates select="//songTitle"/></h3>
        <h4><xsl:text>Artist: </xsl:text><xsl:apply-templates select="//artist"/></h4>
        <xsl:for-each select="descendant::featuredArtist">
            <h4><xsl:text>Featured Artist: </xsl:text><xsl:apply-templates/></h4>
        </xsl:for-each>
        <xsl:for-each select="descendant::producer">
            <h5><xsl:text>Producer: </xsl:text><xsl:apply-templates/></h5>
        </xsl:for-each>
        <h5><xsl:text>Album: </xsl:text><xsl:apply-templates select="//album"/></h5>
        <h5><xsl:text>Certification: </xsl:text><xsl:apply-templates select="descendant::certification"/></h5>
        <xsl:apply-templates select="../lyrics"></xsl:apply-templates>
        <xsl:text> </xsl:text><br/><xsl:text> </xsl:text>
        <hr/>
    </xsl:template>
    
    
    <xsl:template match="lyrics">
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