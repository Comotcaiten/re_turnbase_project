class_name StatusDB

enum StatusID {NONE, PSN, BRN, SLP, PAR, FRZ}

static var db: Maps = Maps.new(
    typeof(1), 
    0,
    {
        StatusID.PSN: StatusPoision.new(
            "Poision",
            "",
            "has take poisioned",
            12
        )
    }
)