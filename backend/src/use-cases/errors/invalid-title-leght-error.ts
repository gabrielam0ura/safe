export class InvalidTitleLeghtError extends Error {
    constructor() {
      super('Title shoud be longer than 3 and shorter than 30 characteres.')
    }
  }