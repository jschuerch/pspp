/**
 * User: Karl Rege
 */


class Calculator {

    static double stack[] = new double[10];
    static int sp = 0;

    static void push(double val) {
        stack[sp++] = val;
    }

    static double pop() {
        return stack[--sp];
    }

    static void expr() throws Exception {
        term();
        while (Scanner.la == Token.PLUS
                || Scanner.la == Token.MINUS) {
            Scanner.scan();
            int op = Scanner.token.kind;
            term();
            if (op == Token.PLUS)
                push(pop() + pop());
            else
                push(-pop() + pop());
        }
    }

    static void term() throws Exception {
        factor();
        while (Scanner.la == Token.TIMES || Scanner.la == Token.SLASH) {
            Scanner.scan();
            int op = Scanner.token.kind;
            factor();
            if (op == Token.TIMES)
                push(pop() * pop());
            else
                push(1 / pop() * pop());
        }
    }

    static void factor() throws Exception {
        if (Scanner.la == Token.LBRACK) {
            Scanner.scan();
            expr();
            Scanner.check(Token.RBRACK);
        } else if (Scanner.la == Token.NUMBER) {
            Scanner.scan();
            push(Scanner.token.val);
        } else if (Scanner.la == Token.IDENT) {
            Scanner.scan();
            switch (Scanner.token.str) {
				case "PI":
					push(3.14159265359);
					break;
				case "E":
					push(2.71828182846);
					break;
			}
        }
    }

    public static void main(String[] args) throws Exception {
        Scanner.init("3+2-4");
        Scanner.scan();
        expr();
        System.out.println("result=" + pop());

        Scanner.init("4*PI/E");
        Scanner.scan();
        expr();
        System.out.println("result=" + pop());
    }

}
