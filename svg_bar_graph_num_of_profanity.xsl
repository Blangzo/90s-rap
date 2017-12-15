<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- global vars -->
    <xsl:variable name="songColl" select="collection('markedup_songs')"/>
    <xsl:variable name="numSongs" select="count($songColl//song)"/>
    <xsl:variable name="phraseMax"
        select="
            max(for $file in $songColl//song
            return
            count($file//phrase[@type='profanity']))"/>
    <xsl:variable name="temp2" select="$songColl//song[count(//phrase[@type='profanity']) eq $phraseMax]"/>
    <xsl:variable name="Xinterval" select="100"/>
    <!--<xsl:variable name="width" select="$numSongs * ($Xinterval + 1) + 500"/>
    <xsl:variable name="height" select="$phraseMax div 10 * $Yinterval + 300"/>-->
    <!-- start -->
    <xsl:template match="/">
        <xsl:comment><xsl:value-of select="$phraseMax"/></xsl:comment>
        <xsl:comment>phrasemax file: <xsl:apply-templates select="$temp2//songTitle"/></xsl:comment>
        <svg xmlns="http://www.w3.org/2000/svg" width="{5000}" height="{450}"
            viewBox="0 0 {5000} {450}">
            <g transform="translate(50 {200})">
                <text x="90" y="{(-$phraseMax - 15) * 2}" fill="red">Bar graph of the count of profanity used in
                    each of the songs.</text>
                <!--X axis: -->
                <line x1="0" y1="0" x2="{$numSongs * ($Xinterval+1)}" y2="0" stroke-width="3"
                    stroke="black"/>
                <!--Y axis: -->
                <line x1="0" y1="0" x2="0" y2="{(-$phraseMax - 10) * 2}" stroke-width="3" stroke="black"/>
                <!--Y axis hashmarks and hashlines -->
                <xsl:for-each select="1 to xs:integer($phraseMax)">
                    <xsl:if test=". mod 10 = 0">
                        <xsl:variable name="HashLocator" select=". * 2"/>
                        <xsl:variable name="HashLabel" select="."/>
                        <text x="-5" y="{-$HashLocator + 5}" fill="red" text-anchor="end">
                            <xsl:value-of select="."/>
                        </text>
                        <line x1="0" y1="{-. * 2}" x2="{$numSongs * ($Xinterval+1)}" y2="{-. * 2}"
                            stroke="red" stroke-width=".5" stroke-dasharray="30"/>
                    </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="$songColl//song">
                    <xsl:variable name="Pos" select="position()"/>
                    <xsl:variable name="xPos" select="$Pos * $Xinterval - $Xinterval div 2"/>
                    <xsl:variable name="color">
                        <xsl:choose>
                            <xsl:when test="//artist = '2Pac'">Black</xsl:when>
                            <xsl:when test="//artist = 'Eminem'">Red</xsl:when>
                            <xsl:otherwise>Yellow</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- X axis labels: -->
                    <text x="{$xPos}" y="15" fill="{$color}" text-anchor="beginning"
                        transform="rotate(50 {$xPos} 25)">
                        <xsl:apply-templates select="//songTitle"/>
                        -
                        <xsl:apply-templates select="//certification"/>
                    </text>
                    <!-- rectangle -->
                    <rect width="50" height="{count(//phrase[@type='profanity']) * 2}" x="{$xPos}" y="{-count(//phrase[@type='profanity']) * 2}"
                        stroke="black" stroke-width=".5" fill="{$color}"/>
                    <xsl:comment><xsl:apply-templates select="-count(//phrase[@type='profanity'])"/></xsl:comment>
                    <!--<xsl:if test="$Pos ne last()">
                        <line x1="{$Pos * $Xinterval - $Xinterval div 2}"
                            y1="{count(descendant::app) * $Yinterval}"
                            x2="{($Pos + 1) * $Xinterval - $Xinterval div 2}"
                            y2="{count($songColl//song[descendant::title = current()//idno + 1]//app) * $Yinterval}"
                            stroke-width="2" stroke="green"/>
                    </xsl:if>-->
                </xsl:for-each>
                <!-- Legend -->
                <xsl:variable name="max_xval" select="$numSongs * ($Xinterval+1)"/>
                <text x ="{$max_xval+20}" y ="-140" style="font-size:24; text-decoration: underline;">Legend: Artist</text>
                <text>
                    <tspan x="{$max_xval+20}" y="-120" fill = "red" style="font-size:18; text-decoration: none;">Eminem</tspan>
                    <tspan x="{$max_xval+20}" y="-100" fill = "black" style="font-size:18; text-decoration: none;">Tupac</tspan>
                </text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
