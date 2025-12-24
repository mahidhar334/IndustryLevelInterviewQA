import { LightningElement } from 'lwc';

export default class QuizApp extends LightningElement {
    myQuestions = [
        {
            id: "Question1",
            question: "Which is not a template loop?",
            answers: [
                { label: "for:each", value: "a" },
                { label: "iterator:loop", value: "b" },
                { label: "map:loop", value: "c" }
            ],
            correctAnswer: "c",
            selectedAnswer: null
        },
        {
            id: "Question2",
            question: "Which is not a component of LWC?",
            answers: [
                { label: ".svg", value: "a" },
                { label: ".css", value: "b" },
                { label: "apex", value: "c" }
            ],
            correctAnswer: "c",
            selectedAnswer: null
        },
        {
            id: "Question3",
            question: "Which is a decorator?",
            answers: [
                { label: "Api", value: "a" },
                { label: "Track", value: "b" },
                { label: "@API", value: "c" }
            ],
            correctAnswer: "c",
            selectedAnswer: null
        },
        {
            id: "Question4",
            question: "How do you make LWC available in a flexipage?",
            answers: [
                { label: "is exposed = true", value: "a" },
                { label: "is expose = false", value: "b" },
                { label: "none, it's always exposed", value: "c" }
            ],
            correctAnswer: "a",
            selectedAnswer: null
        }
    ];

    handleAnswerChange(event) {
        const questionId = event.target.name;
        const selectedValue = event.detail.value;

        this.myQuestions = this.myQuestions.map(question => {
            if (question.id === questionId) {
                return { ...question, selectedAnswer: selectedValue };
            }
            return question;
        });
    }
}