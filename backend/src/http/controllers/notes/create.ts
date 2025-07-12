import { makeCreateNoteUseCase } from '@/use-cases/factories/make-create-note-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'
import { callDefaultUserId } from '@/lib/default-user'

export async function create(request: FastifyRequest, reply: FastifyReply) {
  const createNoteBodySchema = z.object({
    title: z.string().min(3, "O titulo deve ter no minimo 3 caracteres").max(30, "O titulo deve ter no maximo 30 caracteres"),
    content: z.string().min(10, "O conteúdo deve ter no minimo 10 caracteres").max(300, "O conteúdo deve ter no maximo 300 caracteres"),
  })

  const { title, content } =
  createNoteBodySchema.parse(request.body)

  const createNoteUseCase = makeCreateNoteUseCase()

  await createNoteUseCase.execute({
    title,
    content,
    userId: await callDefaultUserId(),
  })

  return reply.status(201).send()
}