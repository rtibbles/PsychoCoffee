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
    "Adobe Jenson"
    "Adobe Text"
    "Albertus"
    "Aldus"
    "Alexandria"
    "Algerian"
    "American Typewriter"
    "Antiqua"
    "Arno"
    "Aster"
    "Aurora"
    "News 706"
    "Baskerville"
    "Bebas"
    "Bebas Neue"
    "Bell"
    "Bembo"
    "Bembo Schoolbook"
    "Berkeley Old Style"
    "Bernhard Modern"
    "Bodoni"
    "Bauer Bodoni"
    "Book Antiqua"
    "Bookman"
    "Bordeaux Roman"
    "Bulmer"
    "Caledonia"
    "Californian FB"
    "Calisto MT"
    "Cambria"
    "Capitals"
    "Cartier"
    "Caslon"
    "Wyld"
    "Caslon Antique"
    "Fifteenth Century"
    "Catull"
    "Centaur"
    "Century Old Style"
    "Century Schoolbook"
    "New Century Schoolbook"
    "Century Schoolbook Infant"
    "Chaparral"
    "Charis SIL"
    "Charter"
    "Cheltenham"
    "Clearface"
    "Cochin"
    "Colonna"
    "Computer Modern"
    "Concrete Roman"
    "Constantia"
    "Cooper Black"
    "Corona"
    "News 705"
    "DejaVu Serif"
    "Didot"
    "Droid Serif"
    "Ecotype"
    "Elephant"
    "Emerson"
    "Espy Serif"
    "Excelsior"
    "News 702"
    "Fairfield"
    "FF Scala"
    "Footlight"
    "FreeSerif"
    "Friz Quadrata"
    "Garamond"
    "Gentium"
    "Georgia"
    "Gloucester"
    "Goudy Old Style"
    "Goudy"
    "Goudy Pro Font"
    "Goudy Schoolbook"
    "Granjon"
    "Heather"
    "Hercules"
    "High Tower Text"
    "Hiroshige"
    "Hoefler Text"
    "Humana Serif"
    "Imprint"
    "Ionic No. 5"
    "News 701"
    "ITC Benguiat"
    "Janson"
    "Jenson"
    "Joanna"
    "Korinna"
    "Kursivschrift"
    "Legacy Serif"
    "Lexicon"
    "Liberation Serif"
    "Linux Libertine"
    "Literaturnaya"
    "Lucida Bright"
    "Melior","Memphis"
    "Miller"
    "Minion"
    "Modern"
    "Mona Lisa"
    "Mrs Eaves"
    "MS Serif"
    "New York"
    "Nimbus Roman"
    "NPS Rawlinson Roadway"
    "OCR A Extended"
    "Palatino"
    "Perpetua"
    "Plantin"
    "Plantin Schoolbook"
    "Playbill"
    "Poor Richard"
    "Renault"
    "Requiem"
    "Roman"
    "Rotis Serif"
    "Sabon"
    "Seagull"
    "Sistina"
    "Souvenir"
    "STIX"
    "Stone Informal"
    "Stone Serif"
    "Sylfaen"
    "Times New Roman"
    "Times"
    "Trajan"
    "Trinité"
    "Trump Mediaeval"
    "Utopia"
    "Vale Type"
    "Vera Serif"
    "Versailles"
    "Wanted"
    "Weiss"
    "Wide Latin"
    "Windsor"
    "XITS"
    "Apex"
    "Archer"
    "Athens"
    "Cholla Slab"
    "City"
    "Clarendon"
    "Courier"
    "Egyptienne"
    "Guardian Egyptian"
    "Lexia"
    "Museo Slab"
    "Nilland"
    "Rockwell"
    "Skeleton Antique"
    "Tower"
    "Abadi"
    "Agency FB"
    "Akzidenz-Grotesk"
    "Andalé Sans"
    "Aptifer"
    "Arial"
    "Arial Unicode MS"
    "Avant Garde Gothic"
    "Avenir"
    "Bank Gothic"
    "Barmeno"
    "Bauhaus"
    "Bell Centennial"
    "Bell Gothic"
    "Benguiat Gothic"
    "Berlin Sans"
    "Beteckna"
    "Blue Highway"
    "Brandon Grotesque"
    "Cabin"
    "Cafeteria"
    "Calibri"
    "Casey"
    "Century Gothic"
    "Charcoal"
    "Chicago"
    "Clearface Gothic"
    "Clearview"
    "Co Headline"
    "Co Text"
    "Compacta"
    "Corbel"
    "DejaVu Sans"
    "Dotum"
    "Droid Sans"
    "Dyslexie"
    "Ecofont"
    "Eras"
    "Espy Sans"
    "Nu Sans"
    "Eurocrat"
    "Eurostile","Square 721"
    "FF Dax"
    "FF Meta"
    "FF Scala Sans"
    "Flama"
    "Formata"
    "Franklin Gothic"
    "FreeSans"
    "Frutiger"
    "Frutiger Next"
    "Futura"
    "Geneva"
    "Gill Sans"
    "Gill Sans Schoolbook"
    "Gotham"
    "Haettenschweiler"
    "Handel Gothic"
    "Denmark"
    "Hei"
    "Helvetica"
    "Helvetica Neue"
    "Swiss 721"
    "Highway Gothic"
    "Hiroshige Sans"
    "Hobo"
    "Impact"
    "Industria"
    "Interstate"
    "Johnston/New Johnston"
    "Kabel"
    "Lato"
    "ITC Legacy Sans"
    "Lexia Readable"
    "Liberation Sans"
    "Lucida Sans"
    "Meiryo"
    "Microgramma"
    "Motorway"
    "MS Sans Serif"
    "Museo Sans"
    "Myriad"
    "Neutraface"
    "Neuzeit S"
    "News Gothic"
    "Nimbus Sans L"
    "Nina"
    "Open Sans"
    "Optima"
    "Parisine"
    "Pricedown"
    "Prima Sans"
    "PT Sans"
    "Rail Alphabet"
    "Revue"
    "Roboto"
    "Rotis Sans"
    "Segoe UI"
    "Skia"
    "Souvenir Gothic"
    "ITC Stone Sans"
    "Syntax"
    "Tahoma"
    "Template Gothic"
    "Thesis Sans"
    "Tiresias"
    "Trade Gothic"
    "Transport"
    "Trebuchet MS"
    "Trump Gothic"
    "Twentieth Century"
    "Ubuntu"
    "Univers"
    "Zurich"
    "Vera Sans"
    "Verdana"
    "Virtue"
    "Amsterdam Old Style"
    "Divona"
    "Nyala"
    "Portobello"
    "Rotis Semi Serif"
    "Tema Cantante"
    "Andale Mono"
    "Anonymous and Anonymous Pro"
    "Arial Monospaced"
    "BatangChe"
    "Bitstream Vera"
    "Consolas"
    "CourierHP"
    "Courier New"
    "CourierPS"
    "Fontcraft Courier"
    "DejaVu Sans Mono"
    "Droid Sans Mono"
    "Everson Mono"
    "Fedra Mono"
    "Fixed"
    "Fixedsys"
    "Fixedsys Excelsior"
    "HyperFont","Inconsolata"
    "KaiTi"
    "Letter Gothic"
    "Liberation Mono"
    "Lucida Console"
    "Lucida Sans Typewriter"
    "Lucida Typewriter"
    "Menlo"
    "MICR"
    "Miriam Fixed"
    "Monaco"
    "Monofur"
    "Monospace"
    "MS Gothic"
    "MS Mincho"
    "Nimbus Mono L"
    "OCR-A"
    "OCR-B"
    "Orator"
    "Ormaxx"
    "PragmataPro"
    "Prestige Elite"
    "ProFont"
    "Proggy programming fonts"
    "SimHei"
    "SimSun"
    "Small Fonts"
    "Sydnie"
    "Terminal"
    "Tex Gyre Cursor"
    "Trixie"
    "Ubuntu Mono"
    "UM Typewriter"
    "Vera Sans Mono"
    "William Monospace"
    "Balloon"
    "Brush Script"
    "Choc"
    "Dom Casual"
    "Dragonwick"
    "Mistral"
    "Papyrus"
    "Segoe Script"
    "Tempus Sans"
    "Amazone"
    "American Scribe"
    "AMS Euler"
    "Apple Chancery"
    "Aquiline"
    "Aristocrat"
    "Bickley Script"
    "Civitype"
    "Codex"
    "Edwardian Script"
    "Forte"
    "French Script"
    "ITC Zapf Chancery"
    "Kuenstler Script"
    "Monotype Corsiva"
    "Old English Text MT"
    "Palace Script"
    "Park Avenue"
    "Scriptina"
    "Shelley Volante"
    "Vivaldi"
    "Vladimir Script"
    "Zapfino"
    "Andy"
    "Ashley Script"
    "Cézanne"
    "Chalkboard"
    "Comic Sans MS"
    "Fontoon"
    "Irregularis"
    "Jefferson"
    "Kristen"
    "Lucida Handwriting"
    "Rage Italic"
    "Rufscript"
    "Scribble"
    "Soupbone"
    "Tekton"
    "Alecko"
    "Cinderella"
    "Coronet"
    "Cupola"
    "Curlz"
    "Magnificat"
    "Script"
    "American Text"
    "Bastard"
    "Breitkopf Fraktur"
    "Cloister Black"
    "Fette Fraktur"
    "Fletcher"
    "Fraktur"
    "Goudy Text"
    "Lucida Blackletter"
    "Old English Text"
    "Schwabacher","Wedding Text"
    "Aegyptus"
    "Aharoni"
    "Aisha"
    "Amienne"
    "Batak Script"
    "Chandas"
    "Grecs du roi"
    "Hanacaraka"
    "Japanese Gothic"
    "Jomolhari"
    "Kochi"
    "Koren"
    "Lontara Script"
    "Maiola"
    "Malgun Gothic"
    "Microsoft JhengHei"
    "Microsoft YaHei"
    "Minchō"
    "Ming"
    "Mona"
    "Nassim"
    "Nastaliq Navees"
    "Neacademia"
    "Perpetua Greek"
    "Porson"
    "Skolar"
    "Skolar Devanagari"
    "Sundanese Unicode"
    "Sutturah"
    "Tai Le Valentinium"
    "Tengwar"
    "Tibetan Machine Uni"
    "Tunga"
    "Wadalab"
    "Wilson Greek"
    "Alphabetum"
    "Batang"
    "Gungsuh"
    "Bitstream Cyberbit"
    "ClearlyU"
    "Code2000"
    "Code2001"
    "Code2002"
    "DejaVu fonts"
    "Doulos SIL"
    "Fallback font"
    "Free UCS Outline Fonts"
    "FreeFont"
    "GNU Unifont"
    "Georgia Ref"
    "Gulim"
    "New Gulim"
    "Junicode"
    "LastResort"
    "Lucida Grande"
    "Lucida Sans Unicode"
    "Nimbus Sans Global"
    "Squarish Sans CT v0.10"
    "Symbola"
    "Titus Cyberbit Basic"
    "Verdana Ref"
    "Y.OzFontN"
    "Apple Symbols"
    "Asana-Math"
    "Blackboard bold"
    "Bookshelf Symbol 7"
    "Braille"
    "Cambria Math"
    "Commercial Pi"
    "Corel"
    "Erler Dingbats"
    "HM Phonetic"
    "Lucida Math"
    "Marlett"
    "Mathematical Pi"
    "Morse Code"
    "OpenSymbol"
    "RichStyle"
    "Symbol"
    "SymbolPS"
    "Webdings"
    "Wingdings"
    "Wingdings 2"
    "Wingdings 3"
    "Zapf Dingbats"
    "Abracadabra"
    "Ad Lib"
    "Allegro"
    "Andreas"
    "Arnold Böcklin"
    "Astur"
    "Balloon Pop Outlaw Black"
    "Banco"
    "Beat"
    "Braggadocio"
    "Broadway"
    "Ellington"
    "Exablock"
    "Exocet","FIG Script"
    "Gabriola"
    "Gigi"
    "Harlow Solid"
    "Harrington"
    "Horizon"
    "Jim Crow"
    "Jokerman"
    "Juice"
    "Lo-Type"
    "Magneto"
    "Megadeth"
    "Neuland"
    "Peignot"
    "Ravie"
    "San Francisco"
    "Showcard Gothic"
    "Snap"
    "Stencil"
    "Umbra"
    "Westminster"
    "Willow"
    "Bagel"
    "Lithos"
    "Talmud"
    "3x3"
    "Compatil"
    "Generis"
    "Grasset"
    "LED"
    "Luxi"
    "System"
]

# Based on algorithm outlined in P. Eckersley, 2010
module.exports = fingerprint = ->
    window.navigator.userAgent +
        window.navigator.cookieEnabled +
        (value.name for key,value of window.navigator.plugins).join(",") +
        window.screen.height +
        window.screen.width +
        window.screen.colorDepth +
        (font for font in fontList when isFontAvailable(font)).join(",")