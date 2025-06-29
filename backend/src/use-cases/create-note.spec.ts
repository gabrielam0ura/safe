import { InMemoryNotesRepository } from '@/repositories/in-memory/in-memory-notes-repository'
import { beforeEach, describe, expect, it } from 'vitest'
import { CreateNoteUseCase } from './create-note'
import { InMemoryUsersRepository } from '@/repositories/in-memory/in-memory-users-repository'
import type { User } from '@prisma/client'
import { any } from 'zod'
import { InvalidTitleLeghtError } from './errors/invalid-title-leght-error'
import { InvalidContentLenghtError } from './errors/invalid-content-leght-error'

let notesRepository: InMemoryNotesRepository
let usersRepository: InMemoryUsersRepository
let sut: CreateNoteUseCase

let user: User


describe('Create note use case tests', () => {
  beforeEach(async () => {
    notesRepository = new InMemoryNotesRepository()
    usersRepository = new InMemoryUsersRepository()
    sut = new CreateNoteUseCase(notesRepository)

    user = await usersRepository.create({
      name: "Jonny Test",
      email: "Jonnytest@test.com",
      password_hash: "hashedpassword",
    })
    
  })

  it('should be able to create a new note', async () => {
    const { note } = await sut.execute({
      title: "Test note",
      content: "testing the note creation and verify it's working",
      userId: user.id
    })

    expect(note.id).toEqual(expect.any(String))
  })

  it('should not be able to create a new note with shorter then bottom limit caracteres title', async () => {

    await expect(() => sut.execute({
      title: "Te",
      content: "testing the note creation and verify it's working",
      userId: user.id
    })).rejects.toBeInstanceOf(InvalidTitleLeghtError)
  })

  it('should not be able to create a new note with longer then top limit caracteres title', async () => {

    await expect(() => sut.execute({
      title: "titulo de teste muito longo para ter mais de 30 caracteres e subir o erro",
      content: "testing the note creation and verify it's working",
      userId: user.id
    })).rejects.toBeInstanceOf(InvalidTitleLeghtError)
  })
  it('should not be able to create a new note with shorter then bottom limit caracteres content', async () => {

    await expect(() => sut.execute({
      title: "Test note",
      content: "testing the ",
      userId: user.id
    })).rejects.toBeInstanceOf(InvalidContentLenghtError)
  })
  it('should not be able to create a new note with shorter then top limit caracteres content', async () => {

    await expect(() => sut.execute({
      title: "Test note",
      content: "nota muitooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo grande ",
      userId: user.id
    })).rejects.toBeInstanceOf(InvalidContentLenghtError)
  })

})