import { InMemoryNotesRepository } from '@/repositories/in-memory/in-memory-notes-repository'
import { beforeEach, describe, expect, it } from 'vitest'
import { CreateNoteUseCase } from './create-note'
import { InMemoryUsersRepository } from '@/repositories/in-memory/in-memory-users-repository'
import type { User } from '@prisma/client'
import { any } from 'zod'

let notesRepository: InMemoryNotesRepository
let usersRepository: InMemoryUsersRepository
let sut: CreateNoteUseCase

let user: User


describe('Register use cases tests', () => {
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

})