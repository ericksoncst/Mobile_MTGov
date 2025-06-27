import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class UtilRepository {
  constructor(private configService: ConfigService) {}

  BadRequest(error: any) {
    if (error.response?.data?.message) {
      throw new BadRequestException(`${error.response.data.message}`);
    }
    throw new BadRequestException(`${error}`);
  }
}
