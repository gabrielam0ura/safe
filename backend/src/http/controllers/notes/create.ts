import { makeCreateNoteUseCase } from '@/use-cases/factories/make-create-note-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'

export async function create(request: FastifyRequest, reply: FastifyReply) {
  const createGymBodySchema = z.object({
    title: z.string().min(3, "O titulo deve ter no minimo 3 caracteres").max(30, "O titulo deve ter no maximo 30 caracteres"),
    content: z.string().min(25, "O conteúdo deve ter no minimo 25 caracteres").max(300, "O conteúdo deve ter no maximo 300 caracteres"),
  })

  const { title, content } =
    createGymBodySchema.parse(request.body)

  const createGymUseCase = makeCreateNoteUseCase()

  await createGymUseCase.execute({
    title,
    content,
    userId: "default-user-id",
  })

  return reply.status(201).send()
}