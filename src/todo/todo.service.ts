import { Injectable } from '@nestjs/common';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { TodoRepository } from '../repositories/todo.repository';
import { UtilRepository } from '../repositories/util.repository';

@Injectable()
export class TodoService {
  constructor(
    private readonly repository: TodoRepository,
    private readonly utilRepository: UtilRepository,
  ) {}

  async create(createTodoDto: CreateTodoDto) {
    try {
      return await this.repository.cadastrar(createTodoDto);
    } catch (ex) {
      this.utilRepository.BadRequest(ex);
    }
  }

  async findAll() {
    try {
      return await this.repository.findAll();
    } catch (ex) {
      this.utilRepository.BadRequest(ex);
    }
  }

  async findOne(id: number) {
    try {
      return await this.repository.findOne(id);
    } catch (ex) {
      this.utilRepository.BadRequest(ex);
    }
  }

  async update(id: number, updateTodoDto: UpdateTodoDto) {
    try {
      return await this.repository.update(id, updateTodoDto);
    } catch (ex) {
      this.utilRepository.BadRequest(ex);
    }
  }

  async remove(id: number) {
    try {
      return await this.repository.remove(id);
    } catch (ex) {
      this.utilRepository.BadRequest(ex);
    }
  }
}
