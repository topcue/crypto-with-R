## Hash
## HMAC
## MAC
#############################################

rm(list=ls())

# install.packages("digest")

#################### Hash ####################
rm(list=ls())
library(digest)

##### Hash
hash_input <- "abcd1"
hash_tag <- digest(hash_input, algo="sha256")
print(hash_tag)
nchar(hash_tag)

#################### HMAC ####################
rm(list=ls())

#### HMAC
mac_value <- hmac("my key", "I love you.", algo="sha256")
print(mac_value)

bad_value <- hmac("guess key", "I hate you.", algo="sha256")
print(bad_value)

strsplit(mac_value, "")[[1]] == strsplit(bad_value, "")[[1]]

#################### MAC ####################
rm(list=ls())

##### AES Enc
msg <- as.raw(c(0:15))
print(msg)

enc_key <- as.raw(c(0x10:0x1f))
print(enc_key)

aes <- AES(enc_key, mode="ECB")
ct <- aes$encrypt(msg)
print(ct)

##### HMAC
hmac_key <- as.raw(c(0x20:0x2f))
print(hmac_key)

hmac_tag <- hmac(hmac_key, msg, "sha256", raw=TRUE)
print(hmac_tag)

##### Another PC
# transmitted message (encrypted)
# ------(ct, hmac_tag)------>
# suppose enc_key, hmac_key shared

# raw = TRUE
recovered_pt <- aes$decrypt(ct, raw=TRUE)
print(recovered_pt)

recalc_tag <- hmac(hmac_key, recovered_pt, "sha256")
print(recalc_tag)

# EOF
