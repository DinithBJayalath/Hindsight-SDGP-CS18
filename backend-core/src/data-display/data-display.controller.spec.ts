import { Test, TestingModule } from '@nestjs/testing';
import { DataDisplayController } from './data-display.controller';

describe('DataDisplayController', () => {
  let controller: DataDisplayController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [DataDisplayController],
    }).compile();

    controller = module.get<DataDisplayController>(DataDisplayController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
