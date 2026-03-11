import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';

@Injectable()
export class UsersService {
  constructor(private readonly db: DatabaseService) {}

  async findByEmail(email: string) {
    return this.db.user.findUnique({
      where: { email },
    });
  }

  async findById(id: string) {
    return this.db.user.findUnique({
      where: { id },
    });
  }

  async create(input: { email: string; password: string; role: string }) {
    return this.db.user.create({
      data: {
        email: input.email,
        password: input.password,
        role: input.role,
      },
    });
  }

  async update(id: string, input: any) {
    return this.db.user.update({
      where: { id },
      data: input,
    });
  }

  async delete(id: string) {
    return this.db.user.delete({
      where: { id },
    });
  }
}
