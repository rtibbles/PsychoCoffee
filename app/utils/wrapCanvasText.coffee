module.exports = (t, canvas, maxW, maxH, justify) ->
    maxH = maxH ? 0
    words = t.text.split(" ")
    formatted = ''
    
    # This works only with monospace fonts
    justify = justify || 'left'
    
    # clear newlines
    sansBreaks = t.text.replace(/(\r\n|\n|\r)/gm, "")
    # calc line height
    lineHeight = new fabric.Text(sansBreaks,
        fontFamily: t.fontFamily
        fontSize: t.fontSize
    ).height
    
    # adjust for vertical offset
    maxHAdjusted = if maxH > 0 then maxH - lineHeight else 0
    context = canvas.getContext("2d")
    
    
    context.font = t.fontSize + "px " + t.fontFamily
    currentLine = ''
    breakLineCount = 0
    
    n = 0
    while n < words.length
        isNewLine = currentLine == ""
        testOverlap = currentLine + ' ' + words[n]
        
        # are we over width?
        w = context.measureText(testOverlap).width
        
        # if not, keep adding words
        if w < maxW
            if currentLine != ''
                currentLine += ' '
            currentLine += words[n]
        else
            
            # if this hits, we got a word that need to be hypenated
            if isNewLine
                wordOverlap = ""
                
                # test word length until its over maxW
                for i in [0...words[n].length]
                    wordOverlap += words[n].charAt(i)
                    withHypeh = wordOverlap + "-"
                    
                    if context.measureText(withHypeh).width >= maxW
                        # add hyphen when splitting a word
                        withHypeh =
                            wordOverlap.substr(0,
                                wordOverlap.length - 2) + "-"
                        # update current word with remainder
                        words[n] =
                            words[n].substr(wordOverlap.length
                                - 1, words[n].length)
                        # add hypenated word
                        formatted += withHypeh
                        break

            while justify == 'right' and context.measureText(
                ' ' + currentLine).width < maxW
                currentLine = ' ' + currentLine
            
            while justify == 'center' and context.measureText(
                ' ' + currentLine + ' ').width < maxW
                currentLine = ' ' + currentLine + ' '
            
            formatted += currentLine + '\n'
            breakLineCount++
            currentLine = ""
            
            # restart cycle
            continue

        if maxHAdjusted > 0 and (breakLineCount * lineHeight) > maxHAdjusted
            # add ... at the end indicating text was cutoff
            formatted = formatted.substr(0, formatted.length - 3) + "...\n"
            currentLine = ""
            break
        n++
    
    if currentLine != ''
        while justify == 'right' and context.measureText(
            ' ' + currentLine).width < maxW
            currentLine = ' ' + currentLine
        
        while justify == 'center' and context.measureText(
            ' ' + currentLine + ' ').width < maxW
            currentLine = ' ' + currentLine + ' '
        
        formatted += currentLine + '\n'
        breakLineCount++
        currentLine = ""
    
    # get rid of empy newline at the end
    formatted = formatted.substr(0, formatted.length - 1)
                                                                    
    ret = t.setText(formatted)

    return ret