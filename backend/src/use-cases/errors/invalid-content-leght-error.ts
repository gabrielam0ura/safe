export class InvalidContentLenghtError extends Error {
    constructor() {
      super('O conteúdo deve ter entre 25 e 300 caracteres.')
    }
  }