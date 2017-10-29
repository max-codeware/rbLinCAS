#! /usr/bin/env ruby

STMT_BEG_SET = [TkType.SELECT,
                TkType.FOR,
                TkType.FOREACH,
                TkType.DO,
                TkType.L_IDENT,
                TkType.G_IDENT,
                TkType.EOL,
                TkType.SEMICOLON,
                TkType.L_BRACE,
                TkType.L_BRACKET]
                
STMT_MID_SET = [TkType.SEMICOLON,
                TkType.EOL,
                TkType.ELSE,
                # TkType.UNTIL,
                TkType.R_BRACE]
