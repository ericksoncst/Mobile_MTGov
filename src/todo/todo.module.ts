import { Module } from '@nestjs/common';
import { TodoService } from './todo.service';
import { TodoController } from './todo.controller';
import { HttpModule } from '@nestjs/axios';
import { UtilRepository } from '../repositories/util.repository';
import { TodoRepository } from '../repositories/todo.repository';

@Module({
  imports: [HttpModule],
  controllers: [TodoController],
  providers: [TodoService, UtilRepository, TodoRepository],
})
export class TodoModule {}
