module Regulation.US.LCR.Inflows.Unsecured exposing (..)


import Regulation.US.FR2052A.DataTables.Inflows.Unsecured exposing (..)
import Regulation.US.FR2052A.Fields.CollateralClass as CollateralClass
import Regulation.US.FR2052A.Fields.Insured as Insured
import Regulation.US.FR2052A.Fields.MaturityBucket as MaturityBucket
import Regulation.US.FR2052A.Fields.SubProduct as SubProduct
import Regulation.US.LCR.AmountCalculations exposing (..)
import Regulation.US.LCR.Rule exposing (applyRule)


applyRules : Unsecured -> List ( String, Float )
applyRules flow =
    List.concat
        [ applyRule (match_rule_104_section_33_c flow) "33(c)" flow.maturityAmount
        , applyRule (match_rule_106_section_33_d_1 flow) "33(d)(1)" flow.maturityAmount
        , applyRule (match_rule_109_section_33_d_2 flow) "33(d)(2)" flow.maturityAmount
        ]


{-| (104) Retail Cash Inflow Amount (§.33(c))
-}
match_rule_104_section_33_c : Unsecured -> Bool
match_rule_104_section_33_c flow =
    List.member flow.product [ i_U_5, i_U_6 ]
    -- Maturity Bucket: <= 30 calendar days but not Open
    && (MaturityBucket.isLessThanOrEqual30Days flow.maturityBucket && not (MaturityBucket.isOpen flow.maturityBucket))
    -- Forward Start Amount: NULL
    && (flow.forwardStartAmount == Nothing)
    -- Forward Start Bucket: NULL
    && (flow.forwardStartBucket == Nothing)


{-| (106) Financial and Central Bank Cash Inflow Amount (§.33(d)(1))
-}
match_rule_106_section_33_d_1 : Unsecured -> Bool
match_rule_106_section_33_d_1 flow =
    List.member flow.product [ i_U_1, i_U_2, i_U_4, i_U_5, i_U_6, i_U_8 ]
    -- Maturity Bucket: <= 30 calendar days
    && (MaturityBucket.isLessThanOrEqual30Days flow.maturityBucket)
    -- Forward Start Amount: NULL
    && (flow.forwardStartAmount == Nothing)
    -- Forward Start Bucket: NULL
    && (flow.forwardStartBucket == Nothing)


{-| (109) Non-Financial Wholesale Cash Inflow Amount (§.33(d)(2))
-}
match_rule_109_section_33_d_2 : Unsecured -> Bool
match_rule_109_section_33_d_2 flow =
    List.member flow.product [ i_U_1, i_U_2, i_U_6 ]
    -- Maturity Bucket: <= 30 calendar days
    && (MaturityBucket.isLessThanOrEqual30Days flow.maturityBucket)
    -- Forward Start Amount: NULL
    && (flow.forwardStartAmount == Nothing)
    -- Forward Start Bucket: NULL
    && (flow.forwardStartBucket == Nothing)