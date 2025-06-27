import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';
import { CreateTodoDto } from '../todo/dto/create-todo.dto';
import { UpdateTodoDto } from '../todo/dto/update-todo.dto';

@Injectable()
export class TodoRepository {
  private endpoint_2 = 'https://jsonplaceholder.typicode.com/todos';
  private endpoint: string;
  constructor(
    private configService: ConfigService,
    private httpService: HttpService,
  ) {
    this.endpoint = `http://${this.configService.get<string>(
      'SECURITY_SERVER',
    )}/r1/${this.configService.get<string>(
      'XROAD_INSTANCE',
    )}/${this.configService.get<string>(
      'MEMBER_CLASS',
    )}/${this.configService.get<string>(
      'MEMBER_CODE',
    )}/${this.configService.get<string>('SUBSYSTEMCODE')}`;
  }

  async cadastrar(createTodoDto: CreateTodoDto) {
    // TODO: Implementar método com url cadastrada no XVIA
    // const url = `${this.endpoint}/tramitadorAtendimento/atendente`;
    // const body = {
    //   ...createTodoDto,
    // };
    // const response = await firstValueFrom(
    //   await this.httpService.post(url, body, {
    //     headers: {
    //       'x-road-client': `${this.configService.get<string>('X_ROAD_CLIENT')}`,
    //     },
    //   }),
    // );
    // return response.data;

    const response = await firstValueFrom(
      this.httpService.post(this.endpoint_2, createTodoDto),
    );
    return response.data;
  }

  async findAll() {
    // TODO(fernandosantos): Implementar método
    const response = await firstValueFrom(
      this.httpService.get(this.endpoint_2),
    );
    return response.data;
  }

  async findOne(id: number) {
    const response = await firstValueFrom(
      this.httpService.get(`${this.endpoint_2}/${id}`),
    );
    return response.data;
  }

  async update(id: number, updateTodoDto: UpdateTodoDto) {
    const response = await firstValueFrom(
      this.httpService.put(`${this.endpoint_2}/${id}`, updateTodoDto),
    );
    return response.data;
  }

  async remove(id: number): Promise<void> {
    await firstValueFrom(this.httpService.delete(`${this.endpoint_2}/${id}`));
  }
}
