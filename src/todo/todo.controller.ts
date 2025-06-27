import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Req,
  UseGuards,
  HttpCode,
  Put,
} from '@nestjs/common';
import { TodoService } from './todo.service';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ApiBearerAuth, ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('todo')
export class TodoController {
  constructor(private readonly todoService: TodoService) {}

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Cadastrar',
  })
  @ApiResponse({ status: 200, description: '' })
  @HttpCode(200)
  @Post('/nao-logado/')
  async createNoAuth(@Body() createTodoDto: CreateTodoDto) {
    console.log('cadastrar não logado');
    return await this.todoService.create(createTodoDto);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Obter all',
  })
  @ApiResponse({ status: 200, description: '' })
  @HttpCode(200)
  @Get('/nao-logado/')
  async findAllNoAuth() {
    console.log('Obter all não logado');
    return await this.todoService.findAll();
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Obter por id',
  })
  @ApiResponse({ status: 200, description: '' })
  @HttpCode(200)
  @Get('/nao-logado/buscar-id/:id')
  async findOneNoAuth(@Param('id') id: number) {
    console.log('Obter por id não logado');
    return await this.todoService.findOne(id);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Alterar',
  })
  @ApiResponse({ status: 200, description: '' })
  @HttpCode(200)
  @Put('/nao-logado/update/:id')
  async updateNoAuth(
    @Param('id') id: number,
    @Body() updateTodoDto: UpdateTodoDto,
  ) {
    console.log('Alterar não logado');
    return await this.todoService.update(id, updateTodoDto);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Deletar ',
  })
  @ApiResponse({ status: 200, description: '' })
  @HttpCode(200)
  @Delete('/nao-logado/remove/:id')
  async removeNoAuth(@Param('id') id: number) {
    console.log('deletar não logado');
    return await this.todoService.remove(id);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Cadastrar Com Usuario Logado',
  })
  @ApiResponse({ status: 200, description: '' })
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Post('/logado/')
  async createAuth(@Req() req: any, @Body() createTodoDto: CreateTodoDto) {
    console.log('cadastrar logado - userid:', req.user.userId);
    return await this.todoService.create(createTodoDto);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Obter all Com Usuario Logado',
  })
  @ApiResponse({ status: 200, description: '' })
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Get('/logado/')
  async findAllAuth(@Req() req: any) {
    console.log('Obter all logado - userid:', req.user.userId);
    return await this.todoService.findAll();
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Obter por id Com Usuario Logado',
  })
  @ApiResponse({ status: 200, description: '' })
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Get('/logado/buscar-id/:id')
  async findOneAuth(@Req() req: any, @Param('id') id: number) {
    console.log('Obter por id logado - userid:', req.user.userId);
    return await this.todoService.findOne(id);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Alterar Com Usuario Logado',
  })
  @ApiResponse({ status: 200, description: '' })
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Put('/logado/update/:id')
  async updateAuth(
    @Req() req: any,
    @Param('id') id: number,
    @Body() updateTodoDto: UpdateTodoDto,
  ) {
    console.log('Alterar logado - userid:', req.user.userId);
    return await this.todoService.update(id, updateTodoDto);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Deletar Com Usuario Logado',
  })
  @ApiResponse({ status: 200, description: '' })
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Delete('/logado/remove/:id')
  async removeAuth(@Req() req: any, @Param('id') id: number) {
    console.log('deletar logado - userid:', req.user.userId);
    return await this.todoService.remove(id);
  }
}
