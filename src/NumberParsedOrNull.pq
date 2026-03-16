let
    // NumberParsedOrNull
    // Returns a number (nullable) after culture-aware cleaning and parsing.
    //
    // Parameters:
    //   valueText (any, nullable): the input value
    //   culture (optional text): e.g., "en-GB", "en-US", "de-DE"; defaults to Culture.Current
    //   allowPercent (optional logical): true to allow "12%" -> 0.12; false to reject; defaults to true
    //
    // Output:
    //   nullable number: parsed numeric value, or null when invalid/blank
    NumberParsedOrNull = (valueText as nullable any, optional culture as nullable text, optional allowPercent as nullable logical) as nullable number =>

    let
        // Resolve parameters
        CultureUsedText  = if culture = null then Culture.Current else culture,
        AllowPercent     = if allowPercent = null then true else allowPercent,

        // 1) Coerce to text and normalize whitespace (incl. NBSP)
        RawText          = try Text.From(valueText) otherwise "",
        NBSP             = Character.FromNumber(160),
        NormalWS         = Text.Replace(RawText, NBSP, " "),
        Trimmed          = Text.Trim(NormalWS),

        // 2) Reject blanks early
        IsBlank          = Trimmed = "",

        // 3) Detect letters robustly (no unsupported functions)
        Letters          = List.Combine({{"A".."Z"},{"a".."z"}}),
        WithoutLetters   = Text.Remove(Trimmed, Letters),
        HasLetters       = Text.Length(WithoutLetters) <> Text.Length(Trimmed),

        Result =
            if IsBlank or HasLetters then
                null
            else
                let
                    // 4) Normalize dashes and remove spaces
                    DashNorm1        = Text.Replace(Trimmed, "–", "-"),
                    DashNorm2        = Text.Replace(DashNorm1, "—", "-"),
                    NoSpaces         = Text.Replace(DashNorm2, " ", ""),

                    // 5) Accounting negatives: (123.45) -> -123.45
                    IsParenNegative  = Text.StartsWith(NoSpaces, "(") and Text.EndsWith(NoSpaces, ")"),
                    NoParens         = if IsParenNegative then Text.Range(NoSpaces, 1, Text.Length(NoSpaces) - 2) else NoSpaces,

                    // 6) Remove common currency symbols
                    CurrencyChars    = {"£","$","€","¥","₹","₩","₫","₴","₦","₱","₽"},
                    NoCurrency       = List.Accumulate(CurrencyChars, NoParens, (state, ch) => Text.Replace(state, ch, "")),

                    // 7) Strip leading '+'
                    NoLeadingPlus    = if Text.StartsWith(NoCurrency, "+") then Text.Range(NoCurrency, 1) else NoCurrency,

                    // 8) Optional percent handling
                    HasPercent       = Text.EndsWith(NoLeadingPlus, "%"),
                    NoPercent        = if HasPercent then Text.BeforeDelimiter(NoLeadingPlus, "%") else NoLeadingPlus,

                    // 9) Parse using the selected culture
                    TryNum           = try Number.FromText(NoPercent, CultureUsedText),

                    Parsed           =
                        if TryNum[HasError] then
                            null
                        else
                            let
                                Signed  = if IsParenNegative then -1 * TryNum[Value] else TryNum[Value],
                                WithPct = 
                                    if HasPercent and AllowPercent then Signed / 100 
                                    else if HasPercent and not AllowPercent then null
                                    else Signed
                            in
                                WithPct
                in
                    Parsed
    in
        Result
in
    NumberParsedOrNull
