/*
 *  NSData+Cipher.h
 *  
 *  Provides functions to encrypt and decrypt data
 *
 *  Created by Scott Wasserman on 9/30/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */


@interface NSData (Cipher)

	

//  Encrypt text in string form into "data" form for database using given key
+ (NSData *) encryptString:(NSString*)plaintext withKey:(NSString*)key;

//  Decrypt data from database into text in string form using given key
+ (NSString *) decryptData:(NSData*)ciphertext withKey:(NSString*)key;
  
/* 
 *  Encrypt the data using the Advanced Encryption Standard: 256 bits 
 *  with the provided key (of type String)
 */
- (NSData *) AES256EncryptWithKey:(NSString *)key;

/* 
 *  Decrypt the data using the Advanced Encryption Standard: 256 bits 
 *  with the provided key (of type String)
 */
- (NSData *) AES256DecryptWithKey:(NSString *)key;
@end
