let
    // CleanDateCultureStatus
    // Validates date-like values using a user-defined culture.
    //
    // Parameters:
    //   dateText (any): the input value to validate
    //   culture (optional text): e.g., "en-GB", "en-US"; defaults to Culture.Current
    //
    // Returns:
    //   "Valid Date <culture>"
    //   "Invalid Date"
    //   "Invalid Format"

    CleanDateCultureStatus = (dateText as nullable any, optional culture as nullable text) as text =>

    let
        // Resolve culture
        CultureUsed = if culture = null then Culture.Current else culture,

        // Convert input to text safely
        RawText     = try Text.From(dateText) otherwise "",
        Trimmed     = Text.Trim(RawText),

        // Quick empty check
        IsBlank     = Trimmed = "",

        // Attempt culture-aware date parse
        TryDate     = try Date.FromText(Trimmed, CultureUsed),
        ParsedDate  = if TryDate[HasError] then null else TryDate[Value],

        Result =
            if IsBlank then
                "Invalid Format"
            else if ParsedDate = null then
                "Invalid Date"
            else
                "Valid Date " & CultureUsed

    in
        Result
in
    CleanDateCultureStatus
