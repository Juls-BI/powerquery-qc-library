let
    // CleanNumberCultureStatus
    // Validates and classifies numeric-like inputs using a user-defined culture.
    //
    // Parameters:
    //   valueText (any):               The input value (text/number/nullable) to validate.
    //   culture (optional text):       Culture code like "en-GB", "en-US", "de-DE".
    //                                  If null, Culture.Current is used.
    //   allowPercent (optional logical): If true (default), "12%" is accepted and interpreted as 0.12.
    //                                    If false, any "%" makes it invalid.
    //
    // Returns (text):
    //   - "Valid Number <culture>"
    //   - "Invalid Number"
    //   - "Invalid Format"
    CleanNumberCultureStatus = (valueText as nullable any, optional culture as nullable text, optional allowPercent as nullable logical) as text =>
    let
        // Resolve culture and options
        CultureUsedText   = if culture = null then Culture.Current else culture,
        AllowPercent      = if allowPercent = null then true else allowPercent,

        // 1) Coerce to text and normalize whitespace (incl. NBSP), then trim
        RawText           = try Text.From(valueText) otherwise "",
        NBSP              = Character.FromNumber(160),
        NormalWS          = Text.Replace(RawText, NBSP, " "),
        Trimmed           = Text.Trim(NormalWS),

        // 2) Quick blank check
        IsBlank           = Trimmed = "",

        // 3) Detect letters robustly (no unsupported functions)
        Letters           = List.Combine({{"A".."Z"},{"a".."z"}}),
        WithoutLetters    = Text.Remove(Trimmed, Letters),
        HasLetters        = Text.Length(WithoutLetters) <> Text.Length(Trimmed),

        Status =
            if IsBlank then
                "Invalid Format"
            else if HasLetters then
                "Invalid Number"
            else
                let
                    // 4) Normalize dashes and remove internal spaces
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

                    // 9) Try parsing using culture
                    TryNum           = try Number.FromText(NoPercent, CultureUsedText),

                    ParsedNumber     =
                        if TryNum[HasError] then
                            null
                        else
                            let
                                Signed   = if IsParenNegative then -1 * TryNum[Value] else TryNum[Value],
                                WithPct  =
                                    if HasPercent and AllowPercent then Signed / 100
                                    else if HasPercent and not AllowPercent then null
                                    else Signed
                            in
                                WithPct
                in
                    if ParsedNumber = null then
                        "Invalid Number"
                    else
                        "Valid Number " & CultureUsedText
    in
        Status
in
    CleanNumberCultureStatus
