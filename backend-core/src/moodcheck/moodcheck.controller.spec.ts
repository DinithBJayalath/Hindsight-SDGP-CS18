import { Test, TestingModule } from '@nestjs/testing';
import { MoodcheckController } from './moodcheck.controller';

describe('MoodcheckController', () => {
  let controller: MoodcheckController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MoodcheckController],
    }).compile();

    controller = module.get<MoodcheckController>(MoodcheckController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
