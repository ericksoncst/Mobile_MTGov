import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env['KEYCLOAK_PUBLIC_KEY'],
    });
  }

  async validate(payload: any) {
    const user = {
      userId: payload.clientId || payload.preferred_username,
      name: payload.name,
      email: payload.email,
      scope: payload.scope,
    };

    return user;
  }
}
