let
    // DateParsedOrNull
    // Returns a Date (nullable) after culture-aware parsing.
    //
    // Parameters:
    //   dateText (nullable any): the input value to be parsed
    //   culture (optional text): a culture code such as "en-GB" or "en-US";
    //                            defaults to Culture.Current
    //
    // Output:
    //   nullable date: the parsed Date value, or null when the input
    //   is invalid, blank, or cannot be interpreted as a date in the
    //   specified culture.
    DateParsedOrNull = (dateText as nullable any, optional culture as nullable text) as nullable date =>
    let
        // Determine culture (fallback is system's current culture)
        CultureUsed = if culture = null then Culture.Current else culture,

        // Convert to text safely, then trim whitespace
        RawText     = try Text.From(dateText) otherwise "",
        Trimmed     = Text.Trim(RawText),

        // Try cultural date parsing
        TryDate     = try Date.FromText(Trimmed, CultureUsed),
        ParsedDate  = if TryDate[HasError] then null else TryDate[Value]
    in
        ParsedDate
in
    DateParsedOrNull
