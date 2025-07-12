export class InvalidContentLenghtError extends Error {
    constructor() {
      super('Content shoud be longer than 10 and shorter than 300 characteres.')
    }
  }