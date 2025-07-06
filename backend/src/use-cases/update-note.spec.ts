import { InMemoryNotesRepository } from "@/repositories/in-memory/in-memory-notes-repository"
import { beforeEach, describe, expect, it } from "vitest"
import { UpdateNoteUseCase } from "./update-note"
import type { NotesRepository } from "@/repositories/notes-repository"
import { InMemoryUsersRepository } from "@/repositories/in-memory/in-memory-users-repository"
import type { User } from "@prisma/client"
import { InvalidContentLenghtError } from "./errors/invalid-content-leght-error"
import { InvalidTitleLeghtError } from "./errors/invalid-title-leght-error"


describe('Update Note Use Case', () => {

    let usersRepository: InMemoryUsersRepository
    let notesRepository: NotesRepository 
    let sut: UpdateNoteUseCase

    let user: User

  beforeEach( async () => {
    notesRepository = new InMemoryNotesRepository()
    usersRepository = new InMemoryUsersRepository()
    sut = new UpdateNoteUseCase(notesRepository)

    user = await usersRepository.create({
        name: "Jonny Test",
        email: "Jonnytest@test.com",
        password_hash: "hashedpassword",
      })
  })

  it('should be able to update a note title', async () => {
    const createdNote = await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    const { note } = await sut.execute({
      noteId: createdNote.id,
      title: 'Teste atualizado',
    })

    expect(note.title).toBe('Teste atualizado')
    expect(note.updatedAt).toEqual(expect.any(Date))
  })

  it('should be able to update a note content', async () => {
    const createdNote = await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    const { note } = await sut.execute({
      noteId: createdNote.id,
      content: 'Novo conteúdo da nota atualizado com pelo menos 30 caracteres',
    })

    expect(note.content).toBe('Novo conteúdo da nota atualizado com pelo menos 30 caracteres')
    expect(note.updatedAt).toEqual(expect.any(Date))
  })

  it('should not be able to update a note content with shorter then bottom limit caracteres title', async () => {
    const createdNote = await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await expect(() =>
        sut.execute({
           noteId: createdNote.id,
           title: 'Te',
        })
    ).rejects.toBeInstanceOf(InvalidTitleLeghtError)
  })

  it('should not be able to update a note content with longer then top limit caracteres title', async () => {
    const createdNote = await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await expect(() =>
        sut.execute({
           noteId: createdNote.id,
           title: 'titulo de teste muito longo para ter mais de 30 caracteres e subir o erro',
        })
    ).rejects.toBeInstanceOf(InvalidTitleLeghtError)
  })

  it('should not be able to update a note content with shorter then bottom limit caracteres content', async () => {
    const createdNote = await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await expect(() =>
        sut.execute({
           noteId: createdNote.id,
           content: 'Teste',
        })
    ).rejects.toBeInstanceOf(InvalidContentLenghtError)
  })
  it('should not be able to update a note content with longer then top limit caracteres content', async () => {
    const createdNote = await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await expect(() =>
        sut.execute({
           noteId: createdNote.id,
           content: 'nota muitooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo grande ',
        })
    ).rejects.toBeInstanceOf(InvalidContentLenghtError)
  })
})