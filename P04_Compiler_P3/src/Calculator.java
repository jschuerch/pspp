import de.inetsoftware.jwebassembly.JWebAssembly;
import de.inetsoftware.jwebassembly.module.*;

/**
 * User: Karl Rege
 */


class Calculator implements Emitter {

    static void expr() throws Exception {
        term();
        while (Scanner.la == Token.PLUS
                || Scanner.la == Token.MINUS) {
            Scanner.scan();
            int op = Scanner.token.kind;
            term();
            if (op == Token.PLUS)
				JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.add,ValueType.f64,0));
            else
				JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.sub,ValueType.f64,0));
        }
    }

    static void term() throws Exception {
        factor();
        while (Scanner.la == Token.TIMES || Scanner.la == Token.SLASH) {
            Scanner.scan();
            int op = Scanner.token.kind;
            factor();
            if (op == Token.TIMES)
				JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.mul,ValueType.f64,0));
            else
				JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.div,ValueType.f64,0));
        }
    }

    static void factor() throws Exception {
        if (Scanner.la == Token.LBRACK) {
            Scanner.scan();
            expr();
            Scanner.check(Token.RBRACK);
        } else if (Scanner.la == Token.NUMBER) {
            Scanner.scan();
			JWebAssembly.il.add(new WasmConstInstruction(Scanner.token.val,0));
        } else if (Scanner.la == Token.IDENT) {
            Scanner.scan();
            switch (Scanner.token.str) {
                case "PI":
					JWebAssembly.il.add(new WasmConstInstruction(3.14159265359,0));
                    break;
                case "E":
					JWebAssembly.il.add(new WasmConstInstruction(2.71828182846,0));
                    break;
                default:
                    JWebAssembly.il.add(new WasmLoadStoreInstruction(true,
                            JWebAssembly.local(ValueType.f64, Scanner.token.str),0));
            }
        }
    }

    public static void main(String[] args) throws Exception {
        //Scanner.init("3+2-4+$arg0");
        //Scanner.init("4*PI/E");
        Scanner.init("4.2 + 3.2*2 + $arg0");
        Scanner.scan();
		JWebAssembly.emitCode(ICalculator.class, new Calculator ());
    }

    interface ICalculator {
    	double calc(double a);
	}

    @Override
    public void emit() {
        try {
            expr();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
