import { Body, Controller, Post, UseGuards, Get, Request } from '@nestjs/common';
import { AuthService, RegisterInput, LoginInput } from './auth.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiResponse } from '@nestjs/swagger';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @ApiResponse({ status: 201, description: 'User registered successfully' })
  async register(@Body() input: RegisterInput) {
    return this.authService.register(input);
  }

  @Post('login')
  @ApiResponse({ status: 200, description: 'User logged in successfully' })
  async login(@Body() input: LoginInput) {
    return this.authService.login(input);
  }

  @Post('refresh')
  @ApiResponse({ status: 200, description: 'Tokens refreshed successfully' })
  async refresh(@Body('refreshToken') refreshToken: string) {
    return this.authService.refresh(refreshToken);
  }

  @UseGuards(JwtAuthGuard)
  @Get('me')
  @ApiResponse({ status: 200, description: 'Current user profile' })
  async getProfile(@Request() req) {
    return { user: req.user };
  }
}
