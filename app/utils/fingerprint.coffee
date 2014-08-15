###
 * Checks if a font is available to be used on a web page.
 *
 * @param {String} fontName The name of the font to check
 * @return {Boolean}
 * @license MIT
 * @copyright Sam Clarke 2013
 * @author Sam Clarke <sam@samclarke.com>
###
body          = document.body
container     = document.createElement('div')
containerCss  = [
    'position:absolute',
    'width:auto',
    'font-size:128px',
    'left:-99999px'
]

# Create a span element to contain the test text.
# Use innerHTML instead of createElement as it's easier
# to apply CSS to.
container.innerHTML = '<span style="' +
    containerCss.join(' !important;') + '">' +
    Array(100).join('wi') +
    '</span>'
container = container.firstChild

calculateWidth = (fontFamily) ->
    container.style.fontFamily = fontFamily

    body.appendChild(container)
    width = container.clientWidth
    body.removeChild(container)

    return width

# Pre calculate the widths of monospace, serif & sans-serif
# to improve performance.
monoWidth  = calculateWidth('monospace')
serifWidth = calculateWidth('serif')
sansWidth  = calculateWidth('sans-serif')

isFontAvailable = (fontName) ->
    return monoWidth != calculateWidth(fontName + ',monospace') or
        sansWidth != calculateWidth(fontName + ',sans-serif') or
        serifWidth != calculateWidth(fontName + ',serif')

fontList = [
    "Arial"
    "Arial Black"
    "Arial Narrow"
    "Arial Rounded MT Bold"
    "Bookman Old Style"
    "Bradley Hand ITC"
    "Century"
    "Century Gothic"
    "Comic Sans MS"
    "Courier"
    "Courier New"
    "Georgia"
    "Gentium"
    "Impact"
    "King"
    "Lucida Console"
    "Lalit"
    "Modena"
    "Monotype Corsiva"
    "Papyrus"
    "Tahoma"
    "TeX"
    "Times"
    "Times New Roman"
    "Trebuchet MS"
    "Verdana"
    "Verona"
    "Helvetica"
    "Gadget"
    "Comic Sans MS5"
    "Georgia1"
    "Impact5"
    "Charcoal6"
    "Monaco5"
    "Lucida Sans Unicode"
    "Lucida Grande"
    "Palatino Linotype"
    "Book Antiqua3"
    "Palatino"
    "Geneva"
    "Trebuchet MS1"
    "Symbol"
    "Webdings"
    "Wingdings"
    "Zapf Dingbats"
    "MS Sans Serif4"
    "MS Serif4"
    "New York6"
]

# TODO - Use Flash based font detection with JS fallback.

# Based on algorithm outlined in P. Eckersley, 2010
module.exports = fingerprint = ->
    window.navigator.userAgent +
        window.navigator.cookieEnabled +
        (value.name for key,value of window.navigator.plugins).join(",") +
        window.screen.height +
        window.screen.width +
        window.screen.colorDepth +
        (font for font in fontList when isFontAvailable(font)).join(",")
