require 'alchemy_api'

AlchemyAPI.key = "95832f7a3c1ace795f69b37a83c2b1de3407f897"

response = AlchemyAPI.search(:sentiment_analysis, text: "#longbeachgrandprix is underway! #racefans #indycar #fastcars #ilovelongbeach #pikeoutlets… https://t.co/nSJVNFLRv2")
p response
