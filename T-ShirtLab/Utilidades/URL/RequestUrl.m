//
//  RequestUrl.m
//  Tomapp
//
//  Created by Christian Fernandez on 20/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "RequestUrl.h"
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"

static NSString *domain = @"http://104.168.177.73/~tshirtlab/index.php?option=com_api&app=";
/*static NSString *appKey = @"Basic cmVzdF90b21hcHA6MTIzNDU2Nzg5";
static NSString *x_CSRF_Token = @"";

static NSString *user = @"rest_tomapp";
static NSString *pass = @"123456789";*/

@implementation RequestUrl

+(NSMutableDictionary *)crearUsuario:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * tipo = [datos objectForKey:@"tipo"];
    NSString * nombre = [datos objectForKey:@"nombre"];
    NSString * email = [datos objectForKey:@"email"];
    NSString * password = [datos objectForKey:@"password"];
    NSString * cedula = [datos objectForKey:@"cedula"];
    NSString * direccion = [datos objectForKey:@"direccion"];
    NSString * ciudad = [datos objectForKey:@"ciudad"];
    NSString * telefono = [datos objectForKey:@"telefono"];
    NSString * celular = [datos objectForKey:@"celular"];
    NSString * apellidos = [datos objectForKey:@"apellidos"];
    
    NSMutableDictionary * data = nil;
    
    if ([tipo isEqualToString:@"persona"]) {
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                tipo, @"tipo",
                nombre, @"nombre",
                email, @"email",
                password, @"password",
                cedula, @"cedula",
                direccion, @"direccion",
                ciudad, @"ciudad",
                telefono, @"telefono",
                celular, @"celular",
                apellidos, @"apellidos",
                nil];
    }else{
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                tipo, @"tipo",
                nombre, @"nombre",
                email, @"email",
                password, @"password",
                [datos objectForKey:@"nit"], @"nit",
                direccion, @"direccion",
                ciudad, @"ciudad",
                telefono, @"telefono",
                celular, @"celular",
                [datos objectForKey:@"contacto"], @"contacto",
                [datos objectForKey:@"empresa"], @"empresa",
                nil];
    }
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@users&resource=users&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * email = [datos objectForKey:@"email"];
    NSString * password = [datos objectForKey:@"password"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         email, @"email",
                                         password, @"password",
                                         nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@users&resource=login&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)obtenerUsuario:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    NSString * uid = [datos objectForKey:@"uid"];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@users&resource=users&key=4526e5f322cbab43da811ab8acce34eb&format=json&id=%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)actualizarUsuario:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * tipo = [datos objectForKey:@"tipo"];
    NSString * nombre = [datos objectForKey:@"nombre"];
    NSString * password = [datos objectForKey:@"password"];
    NSString * cedula = [datos objectForKey:@"cedula"];
    NSString * direccion = [datos objectForKey:@"direccion"];
    NSString * ciudad = [datos objectForKey:@"ciudad"];
    NSString * telefono = [datos objectForKey:@"telefono"];
    NSString * celular = [datos objectForKey:@"celular"];
    NSString * apellidos = [datos objectForKey:@"apellidos"];
    
    NSMutableDictionary * data = nil;
    
    if ([tipo isEqualToString:@"persona"]) {
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                tipo, @"tipo",
                nombre, @"nombre",
                password, @"password",
                cedula, @"cedula",
                direccion, @"direccion",
                ciudad, @"ciudad",
                telefono, @"telefono",
                celular, @"celular",
                apellidos, @"apellidos",
                nil];
    }else{
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                tipo, @"tipo",
                nombre, @"nombre",
                password, @"password",
                [datos objectForKey:@"nit"], @"nit",
                direccion, @"direccion",
                ciudad, @"ciudad",
                telefono, @"telefono",
                celular, @"celular",
                [datos objectForKey:@"contacto"], @"contacto",
                [datos objectForKey:@"empresa"], @"empresa",
                nil];
    }
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@users&resource=users&key=4526e5f322cbab43da811ab8acce34eb&format=json&id=%@",domain,[_defaults objectForKey:@"uid"]];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"PUT"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerBanners{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@banners&resource=banners&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)obtenerSedes{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@tiendas&resource=tiendas&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerNovedades{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@novedades&resource=novedades&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)obtenerDetalleNovedade:(NSString *)idNovedad{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@novedades&resource=novedades&key=4526e5f322cbab43da811ab8acce34eb&format=json&id=%@",domain,idNovedad];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)obtenerQuienesSomos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@quienes&resource=quienes&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerDepartamentos{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@users&resource=users&key=4526e5f322cbab43da811ab8acce34eb&format=json&opt=departamentos",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerCiudades:(NSString *)departamento{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@users&resource=users&key=4526e5f322cbab43da811ab8acce34eb&format=json&opt=ciudades&departamento=%@",domain,departamento];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerDirecciones:(NSString *)idUsuario{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@direcciones&resource=direcciones&key=4526e5f322cbab43da811ab8acce34eb&format=json&uid=%@",domain,idUsuario];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)obtenerUnaDireccion:(NSString *)idDireccion{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@direcciones&resource=direcciones&key=4526e5f322cbab43da811ab8acce34eb&format=json&id=%@",domain,idDireccion];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)actualizarUnaDireccion:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * opt = [datos objectForKey:@"opt"];
    NSString * nombre = [datos objectForKey:@"nombre"];
    NSString * direccion = [datos objectForKey:@"direccion"];
    NSString * telefono = [datos objectForKey:@"telefono"];
    NSString * celular = [datos objectForKey:@"celular"];
    NSString * ciudad = [datos objectForKey:@"ciudad"];
    NSString * idString = [datos objectForKey:@"id"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  opt, @"opt",
                                  nombre, @"nombre",
                                  direccion, @"direccion",
                                  telefono, @"telefono",
                                  celular, @"celular",
                                  ciudad, @"ciudad",
                                  idString, @"idString",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@direcciones&resource=direcciones&resource=direcciones&key=4526e5f322cbab43da811ab8acce34eb&format=json",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

@end
