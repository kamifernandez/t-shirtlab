//
//  RequestUrl.h
//  Tomapp
//
//  Created by Christian Fernandez on 20/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUrl : NSObject

+(NSMutableDictionary *)crearUsuario:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)obtenerUsuario:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)actualizarUsuario:(NSMutableDictionary *)datos;

+(NSMutableArray *)obtenerBanners;

+(NSMutableDictionary *)obtenerSedes;

+(NSMutableArray *)obtenerNovedades;

+(NSMutableDictionary *)obtenerDetalleNovedade:(NSString *)idNovedad;

+(NSMutableDictionary *)obtenerQuienesSomos;

+(NSMutableArray *)obtenerDepartamentos;

+(NSMutableArray *)obtenerCiudades:(NSString *)departamento;

+(NSMutableArray *)obtenerDirecciones:(NSString *)idUsuario;

+(NSMutableDictionary *)obtenerUnaDireccion:(NSString *)idDireccion;

+(NSMutableDictionary *)actualizarUnaDireccion:(NSMutableDictionary *)datos;

@end
