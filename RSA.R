## RSA Enc
## RSA Sign
#############################################

# setwd("/Users/topcue/myR")
rm(list=ls())

# install.packages("openssl")


#################### RSA Enc ####################
rm(list=ls())
library(openssl)

##### RSA encryption (1)
# receiver : Key generate
# keygen() : (private key, public key)
rsa_key <- rsa_keygen(512)
str(rsa_key)

pub_key <- rsa_key$pubkey

# sender : RSA encrypt
msg <- "Hello, RSA world !"
ciphertext <- rsa_encrypt(charToRaw(msg), pub_key)

# receiver : RSA decrypt
decrypt_msg <- rsa_decrypt(ciphertext, rsa_key)
recovered_msg <- rawToChar(decrypt_msg)
print(recovered_msg)

##### RSA encryption (2)
str(rsa_key$data)

pubkey_e <- rsa_key$data$e
n <- rsa_key$data$n
# n = p * q
n2 <- rsa_key$data$q * rsa_key$data$p
print(n == n2)

# cipher2 = msg^e [mod n]
cipher2 <- bignum_mod_exp(bignum(charToRaw(msg)), pubkey_e, n)

# dec_msg <- cipher2^d [mod n]
prikey_d <- rsa_key$data$d
dec_msg <- bignum_mod_exp(bignum(cipher2), prikey_d, n)
dec_txt <- rawToChar(dec_msg)
print(dec_txt)

#################### RSA Sign ####################

rm(list=ls())
rsa_key <- rsa_keygen(512)

##### RSA signature
## (1) AES encryption : PT -> CT
PT <- as.raw(c(240:255))
aes_key <- as.raw(c(0:15))

aes <- AES(aes_key, mode="ECB")
CT <- aes$decrypt(PT, raw=TRUE)

## (2) Hash Tag : PT -> h(PT)=hash_tag
hash_tag <- sha256(PT)

## (3) RSA sign : hash_tag -> RSA_sign
# d : sign key (private key)
sign_key <- rsa_key$data$d
RSA_sign <- bignum_mod_exp(bignum(hash_tag), sign_key, rsa_key$data$n)

## (4) Send data : Alice ---(CT, RSA_sign)---> Bob
verification_key <- rsa_key$data$e
PT2 <- aes$decrypt(CT, raw=TRUE)
hash_tag2 <- sha256(PT2)

recovered_tag <- bignum_mod_exp(RSA_sign, verification_key, rsa_key$data$n)

print(recovered_tag == bignum(hash_tag))

# EOF
