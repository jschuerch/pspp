import com.sun.jdi.Value;
import de.inetsoftware.jwebassembly.JWebAssembly;
import de.inetsoftware.jwebassembly.module.*;

public class Program implements Emitter {

    static void program() throws Exception {
        statementSequence();
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.UNREACHABLE, 0));
    }

    static void statementSequence() throws Exception {
        do {
            statement();
        } while (Scanner.la != Token.EOF && Scanner.la != Token.RCBRACK);
    }

    static void statement() throws Exception {
        switch (Scanner.la) {
            case Token.IDENT:
                assignment();
                break;
            case Token.RETURN:
                returnStatement();
                break;
            case Token.IF:
                ifStatement();
                break;
            case Token.WHILE:
                whileStatement();
                break;
            case Token.LCBRACK:
                block();
                break;
            default:
                System.out.println("bla");
        }
    }

    static void assignment() throws Exception {
        Scanner.check(Token.IDENT);
        int slotNumber = JWebAssembly.local(ValueType.f64, Scanner.token.str);
        Scanner.check(Token.EQUAL);
        Calculator.expr();
        JWebAssembly.il.add(new WasmLoadStoreInstruction(false, slotNumber, 0));
        Scanner.check(Token.SCOLON);
    }

    static void returnStatement() throws Exception {
        Scanner.check(Token.RETURN);
        Calculator.expr();
        Scanner.check(Token.SCOLON);
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.RETURN, null, 0));
    }

    static void ifStatement() throws Exception {
        Scanner.check(Token.IF);
        condition();
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.IF, 0));

        statement();
        if (Scanner.la == Token.ELSE) {
            Scanner.check(Token.ELSE);
            JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.ELSE, 0));
            statement();
        }
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.END, 0));
    }

    static void condition() throws Exception {
        Scanner.check(Token.LBRACK);

        boolean isNot = false;
        if (Scanner.la == Token.NOT) {
            Scanner.check(Token.NOT);
            isNot = true;
        }
        Calculator.expr();
        JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.nearest, ValueType.f64, 0));
        JWebAssembly.il.add(new WasmConvertInstruction(ValueTypeConvertion.d2i, 0));

        if (Scanner.la == Token.LESSTHAN) {
            conditionChecks(isNot, Token.LESSTHAN, NumericOperator.ge_s, NumericOperator.lt_s);
        } else if (Scanner.la == Token.GREATERTHAN) {
            conditionChecks(isNot, Token.GREATERTHAN, NumericOperator.le_s, NumericOperator.gt);
        } else if (Scanner.la == Token.EQUAL) {
            Scanner.check(Token.EQUAL);
            conditionChecks(isNot, Token.EQUAL, NumericOperator.ne, NumericOperator.eq);
        } else if (Scanner.la == Token.NOT) {
            Scanner.check(Token.NOT);
            conditionChecks(isNot, Token.EQUAL, NumericOperator.eq, NumericOperator.ne);
        } else {
            if (isNot) {
                JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.eqz, ValueType.i32, 0));
            } else {
                JWebAssembly.il.add(new WasmConstInstruction(0.0, 0));
                JWebAssembly.il.add(new WasmConvertInstruction(ValueTypeConvertion.d2i, 0));
                JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.ne, ValueType.i32, 0));
            }
        }

        Scanner.check(Token.RBRACK);
    }

    private static void conditionChecks(boolean isNot, int nextTokenToCheck, NumericOperator isNotComparisonOperator, NumericOperator comparisonOperator) throws Exception {
        Scanner.check(nextTokenToCheck);
        Calculator.expr();
        JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.nearest, ValueType.f64, 0));
        JWebAssembly.il.add(new WasmConvertInstruction(ValueTypeConvertion.d2i, 0));
        if (isNot)
            JWebAssembly.il.add(new WasmNumericInstruction(isNotComparisonOperator, ValueType.i32, 0));
        else
            JWebAssembly.il.add(new WasmNumericInstruction(comparisonOperator, ValueType.i32, 0));
    }

    static void block() throws Exception {
        Scanner.check(Token.LCBRACK);
        statementSequence();
        Scanner.check(Token.RCBRACK);
    }

    static void whileStatement() throws Exception {
        Scanner.check(Token.WHILE);
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.BLOCK, 0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.LOOP,0));
        condition();
        JWebAssembly.il.add(new WasmNumericInstruction(NumericOperator.eqz, ValueType.i32,0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.BR_IF, 1,0));
        statement();
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.BR,0,0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.END,0));
        JWebAssembly.il.add(new WasmBlockInstruction(WasmBlockOperator.END,0));
    }

    public static void main(String[] args) throws Exception {
        String bspCode = "x = $arg0; a = 1; b = 2 + a; c = 3 + b;" +
                "if (x) {c = 3;} value = a*x*x + b*x + c;" +
                "return value;";
        String test1 = "m = $arg0 - 42;" +
                "if (m) { a = 7.0 ; } else { a = 5 ; }" +
                "m = m - a; return m;";
        String test2 = "m = $arg0 - 42;" +
                "if (!m) { return 7;" +
                "} else { return 666;" +
                "}";
        String test3 = "m = $arg0; s = 1;" +
                "while(m){ s = s + 1; m = m-1; }" +
                "return s;";
        String test4 = "m = $arg0; s = 1;" +
                "while(m){ s = s * m; m = m-1; }" +
                "return s;";
        String test5 = "m = $arg0; s = 1;" +
                "while(m>2){ s = s * m; m = m-1; }" +
                "return s;";
        String test6 = "m = $arg0;" +
                "s = 1;" +
                "if(m > 10){" +
                "s = 24;" +
                "} else if (m < 4) {" +
                "s = 23;" +
                "} else if (m-5) {" +
                "s = 22;" +
                "} else { " +
                "s = 21;" +
                "}" +
                "return s;";
        String test7 = "m = $arg0;" +
                "s = 1;" +
                "if(!m < 10){" +
                "s = 24;" +
                "} else if (!m > 4) {" +
                "s = 23;" +
                "} else if (!m-5) {" +
                "s = 22;" +
                "} else { " +
                "s = 21;" +
                "}" +
                "return s;";
        String test8 = "m = $arg0;" +
                "if(m == 6){" +
                "return 123;" +
                "} else { " +
                "return m;" +
                "}";
        String test9 = "m = $arg0;" +
                "if(m != 6){" +
                "return m;" +
                "} else { " +
                "return 321;" +
                "}";
        Scanner.init(test5);
        Scanner.scan();
        JWebAssembly.emitCode(IProgram.class, new Program());
    }

    public interface IProgram {
        double main(double arg);
    }

    @Override
    public void emit() {
        try {
            program();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
