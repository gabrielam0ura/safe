export class InvalidTitleLeghtError extends Error {
    constructor() {
      super('O título deve ter entre 3 e 30 caracteres.')
    }
  }