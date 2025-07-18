import { fastify } from "fastify";
import { ZodError } from 'zod'
import cors from '@fastify/cors'
import { env } from "./env";
import { appRoutes } from "./http/routes";

export const app = fastify()

app.register(cors, {
  origin: true,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'], 
})

app.register(appRoutes)

app.setErrorHandler((error, _, reply) => {
    if (error instanceof ZodError) {
      return reply.status(400).send({
        message: 'Validation error.',
        issues: error.format(),
      })
    }
  
    if (env.NODE_ENV !== 'production') {
      console.error(error)
    }
  
    return reply.status(500).send({
      message: 'Internal server error.',
    })
  })