module Syntax.Basic.Record.Quoted where

-- Credit goes to Justin Woo where I found out this documentation
-- was even possible:
-- https://github.com/justinwoo/quoted-record-property/blob/master/src/Main.purs

type QuotedKey = { "key" :: String }

creation :: QuotedKey
creation = { "key" : "value" }

getValue :: String
getValue = creation."key"

emojiKey :: String
emojiKey = { "😆" : "value" }."😆"

asianLanguageKey :: String
asianLanguageKey = { "日本語" : "Japanese" }."日本語"
