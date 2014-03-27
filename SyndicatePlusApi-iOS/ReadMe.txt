To use this API you need to

1 - Create object from the API you want to use.

    ProductsApi *productsApi=[[ProductsApi alloc]initWithPublicKey:@"Your public key" andSecretKey:@"Your private key"];
    
2 - Create object from the data models to add your add.

    ProductData *data=[productsApi getProductById:@"420d6006-a171-4217-8155-af13c848bbbd"];
    
3- Use the dot notation to get the data inside your object.

    NSLog(@"name: %@",data.productName);
    NSLog(@"brand: %@",data.brand.brandName);
    NSLog(@"manf: %@",data.manufacturer.manufacturerName);
