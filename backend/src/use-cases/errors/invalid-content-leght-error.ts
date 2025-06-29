export class InvalidContentLenghtError extends Error {
    constructor() {
      super('Content shoud be longer than 25 and shorter than 300 characteres.')
    }
  }