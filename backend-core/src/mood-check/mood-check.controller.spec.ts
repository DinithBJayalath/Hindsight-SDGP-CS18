import { Test, TestingModule } from '@nestjs/testing';
import { MoodCheckController } from './mood-check.controller';

describe('MoodCheckController', () => {
  let controller: MoodCheckController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MoodCheckController],
    }).compile();

    controller = module.get<MoodCheckController>(MoodCheckController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
